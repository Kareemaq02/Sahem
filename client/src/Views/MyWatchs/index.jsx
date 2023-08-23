import UserWatchlistView from "./Views/UserWatchlistView"
const { Box, Typography } = require("@mui/material");

function Home() {

    return (
        <Box>
            <UserWatchlistView />
        </Box>
    )
}

export default Home