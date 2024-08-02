let path = require("path");
app.get('/.well-known/apple-developer-domain-association.txt', (req, res) => {
    res.sendFile(path.join(__dirname, 'public/well-known/apple-developer-domain-association.txt'));
});