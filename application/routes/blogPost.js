const express = require('express');

const router = express.Router();
const blogPostController = require('../controllers/blogPost');

// CREATE: Show form and handle form submission
router.get('/new', blogPostController.showNewBlogPost);
router.post('/', blogPostController.newBlogPost);

// READ: List all blog posts
router.get('/list', blogPostController.showListBlogPost);
router.get('/', blogPostController.listBlogPost);

// READ: View a single blog post
router.get('/:id/show', blogPostController.showBlogPost);
router.get('/:id', blogPostController.getBlogPost);

// UPDATE: Show edit form and handle updates
router.get('/:id/edit', blogPostController.showUpdateBlogPost);
router.post('/:id', blogPostController.updateBlogPost);

// DELETE: Delete a blog post
router.post('/:id/delete', blogPostController.deleteBlogPost);

module.exports = router;
