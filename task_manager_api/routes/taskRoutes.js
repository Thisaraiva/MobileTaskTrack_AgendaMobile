const express = require('express');
const taskController = require('../controllers/taskController');

const { getTasks, createTask, getTasksByUsername, getTasksByStatus, getTaskById, updateTask, deleteTask, getTasksByDateRange } = require('../controllers/taskController');

const router = express.Router();

// Get all tasks
router.get('/', getTasks);

router.get('/user/:userId', taskController.getTasks); // Consolidated route for all filters
router.post('/', taskController.createTask);

// Create a new task
router.post('/', createTask);

// Get tasks by username
router.get('/user/:username', getTasksByUsername);

// Get tasks by status
router.get('/user/:username/status/:status', getTasksByStatus);

// Get a task by ID
router.get('/:id', getTaskById);

// Update a task by ID
router.put('/:id', updateTask);

// Delete a task by ID
router.delete('/:id', deleteTask);

router.get('/user/:userId/daterange', getTasksByDateRange);

module.exports = router;
