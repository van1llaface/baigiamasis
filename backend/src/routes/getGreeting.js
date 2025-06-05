const GREETING = 'To DO list!';

module.exports = async (req, res) => {
    res.send({
        greeting: GREETING,
    });
};
