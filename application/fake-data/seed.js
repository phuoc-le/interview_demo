const mongoose = require('mongoose');
// eslint-disable-next-line import/no-extraneous-dependencies
const { faker } = require('@faker-js/faker');
const dotenv = require('dotenv');
const BlogPost = require('../models/BlogPost');

dotenv.config({ path: '.env.example' });

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('MongoDB connected');
    // eslint-disable-next-line no-use-before-define
    seedDB();
  })
  .catch((err) => console.log(err));

// Function to generate fake blog posts
const seedDB = async () => {
  // Create an array of fake blog posts
  for (let i = 0; i < 10; i++) {
    const post = new BlogPost({
      title: faker.lorem.sentence(),
      content: faker.lorem.paragraphs(3),
      author: faker.person.fullName(),
    });
    // eslint-disable-next-line no-await-in-loop
    await post.save();
  }

  console.log('Database seeded with fake posts!');
  mongoose.connection.close();
};
