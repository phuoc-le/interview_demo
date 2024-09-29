/**
 * GET /
 * Home page.
 */
exports.index = (req, res) => {
  res.redirect('/blog/list');
};
exports.indexHome = (req, res) => {
  res.render('home', {
    title: 'Home'
  });
};
