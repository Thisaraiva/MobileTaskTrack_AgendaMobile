const express = require('express');
const { createUser, getUsers, getUserById, updateUser, deleteUser, loginUser, getUserByEmail } = require('../controllers/userController');

const router = express.Router();

router.post('/', createUser);
router.get('/', getUsers);
router.get('/:id', getUserById);
router.get('/email/:email', getUserByEmail); // Rota para obter usuário pelo e-mail
router.put('/:id', updateUser);
router.delete('/:id', deleteUser);
router.post('/login', loginUser);

module.exports = router;
