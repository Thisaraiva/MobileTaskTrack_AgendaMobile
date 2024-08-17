const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },  
  title: { type: String, required: true },
  description: { type: String, required: false },
  date: { type: Date, required: true },
  status: { type: String, required: true, enum: ['A fazer', 'Em processo', 'Realizada'] }
});

module.exports = mongoose.model('Task', taskSchema);
