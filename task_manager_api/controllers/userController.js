const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/user');

// Função auxiliar para extrair o primeiro nome
const getFirstName = (fullName) => {
  return fullName.split(' ')[0];
};

exports.createUser = async (req, res) => {
  const { username, email, password, nickname, phone } = req.body;
  try {
    // Criptografar a senha
    const hashedPassword = await bcrypt.hash(password, 10);
    const firstName = getFirstName(username);
    const newUser = new User({
      username,
      email,
      password: hashedPassword, // Armazenar a senha criptografada
      nickname: nickname || firstName,
      phone
    });
    await newUser.save();
    res.status(201).json({
      _id: newUser._id,
      username: newUser.username,
      email: newUser.email,
      nickname: newUser.nickname,
      phone: newUser.phone
    });
  } catch (error) {
    res.status(409).json({ message: error.message });
  }
};

exports.getUsers = async (req, res) => {
  try {
    // Excluir o campo password dos resultados
    const users = await User.find().select('-password');
    res.status(200).json(users);
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

exports.getUserById = async (req, res) => {
  try {
    // Excluir o campo password dos resultados
    const user = await User.findById(req.params.id).select('-password');
    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

exports.getUserByEmail = async (req, res) => {
  try {
    // Excluir o campo password dos resultados
    const user = await User.findOne({ email: req.params.email }).select('-password');
    console.log('User found:', user); // Adicione esta linha para debug
    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

exports.updateUser = async (req, res) => {
  const { id } = req.params;
  const { username, email, password, nickname, phone } = req.body;

  try {
    const updatedFields = { username, email, nickname, phone };
    if (password) {
      updatedFields.password = await bcrypt.hash(password, 10);
    }

    const updatedUser = await User.findByIdAndUpdate(id, updatedFields, { new: true }).select('-password');

    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json(updatedUser);
  } catch (error) {
    res.status(500).json({ error: 'Error updating user' });
  }
};


exports.deleteUser = async (req, res) => {
  const { id } = req.params;
  try {
    const deletedUser = await User.findByIdAndDelete(id).select('-password');
    if (deletedUser) {
      res.status(200).json({ message: 'User deleted successfully' });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.loginUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (user && await bcrypt.compare(password, user.password)) {
      const token = jwt.sign({ id: user._id, email: user.email }, 'your_secret_key', { expiresIn: '1h' });
      res.status(200).json({ token, id: user._id }); // Inclua o ID do usuário na resposta
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

