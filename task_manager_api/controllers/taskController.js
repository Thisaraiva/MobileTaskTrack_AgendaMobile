const Task = require('../models/task');

// Get all tasks
const getTasks = async (req, res) => {
    const { userId } = req.params;
    let { startDate, endDate, status } = req.query;

    console.log(`Received request to fetch tasks for user: ${userId} with filters - startDate: ${startDate}, endDate: ${endDate}, status: ${status}`);

    let query = { userId };

    // Convert dates to proper Date objects if provided
    if (startDate && endDate) {
        startDate = new Date(startDate);
        endDate = new Date(endDate);
        query.date = { $gte: startDate, $lte: endDate };
    }

    if (status) {
        query.status = status;
    }

    try {
        const tasks = await Task.find(query);
        console.log(`Tasks found: ${tasks.length}`);
        res.json(tasks);
    } catch (error) {
        console.error('Error fetching tasks:', error);
        res.status(500).json({ message: error.message });
    }
};


// Create a new task
const createTask = async (req, res) => {
    const task = req.body;
    const newTask = new Task(task);
    try {
        await newTask.save();
        res.status(201).json(newTask);
    } catch (error) {
        res.status(409).json({ message: error.message });
    }
};

// Get tasks by username
const getTasksByUsername = async (req, res) => {
    const { username } = req.params;
    try {
        const tasks = await Task.find({ username });
        res.json(tasks);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Get tasks by status
const getTasksByStatus = async (req, res) => {
    const { username, status } = req.params;
    try {
        const tasks = await Task.find({ username, status });
        res.json(tasks);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Get a task by ID
const getTaskById = async (req, res) => {
    const { id } = req.params;
    try {
        const task = await Task.findById(id);
        if (task) {
            res.status(200).json(task);
        } else {
            res.status(404).json({ message: 'Task not found' });
        }
    } catch (error) {
        res.status(404).json({ message: error.message });
    }
};

// Update a task
const updateTask = async (req, res) => {
    const { id } = req.params;
    const task = req.body;
    try {
        const updatedTask = await Task.findByIdAndUpdate(id, task, { new: true });
        if (updatedTask) {
            res.status(200).json(updatedTask);
        } else {
            res.status(404).json({ message: 'Task not found' });
        }
    } catch (error) {
        res.status(409).json({ message: error.message });
    }
};

// Delete a task
const deleteTask = async (req, res) => {
    const { id } = req.params;
    try {
        const deletedTask = await Task.findByIdAndDelete(id);
        if (deletedTask) {
            res.status(200).json({ message: 'Task deleted successfully' });
        } else {
            res.status(404).json({ message: 'Task not found' });
        }
    } catch (error) {
        res.status(409).json({ message: error.message });
    }
};

const getTasksByDateRange = async (req, res) => {
    const { userId } = req.params;
    const { startDate, endDate } = req.query;

    console.log(`Received request to fetch tasks for user: ${userId}, between ${startDate} and ${endDate}`);

    const parsedStartDate = new Date(startDate);
    const parsedEndDate = new Date(endDate);

    console.log(`Parsed startDate: ${parsedStartDate}`);
    console.log(`Parsed endDate: ${parsedEndDate}`);

    try {
        const tasks = await Task.find({
            userId,
            date: {
                $gte: parsedStartDate,
                $lte: parsedEndDate
            }
        });

        console.log(`Tasks found: ${tasks.length}`);
        tasks.forEach(task => console.log(task));

        res.json(tasks);
    } catch (error) {
        console.error('Error fetching tasks by date range:', error);
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getTasks,
    createTask,
    getTasksByUsername,
    getTasksByStatus,
    getTaskById,
    updateTask,
    deleteTask,
    getTasksByDateRange
};