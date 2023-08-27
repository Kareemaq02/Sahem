import { Box, Card, CardContent, Typography, Chip } from "@mui/material"
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import RadioButtonCheckedIcon from '@mui/icons-material/RadioButtonChecked';
import WatchLaterIcon from '@mui/icons-material/WatchLater';
import FavoriteIcon from '@mui/icons-material/Favorite';

const ShowWatchlist = ({ data }) => {


    return (

        <Box sx={{ display: "grid", gap: 2, width: '100%' }}>
            {data.map((watch) => (
                <Card key={watch.intComplaintId} sx={{ width: '70%', borderRadius: '25px' }}>
                    <CardContent>
                        <Typography variant="h3">
                            <FlexBetween>

                                <Box>
                                    {watch.strFirstName} {watch.strLastName}
                                </Box>
                                <Chip
                                    className="status-chip"
                                    icon={<RadioButtonCheckedIcon />}
                                    color="primary"
                                    label={watch.strStatusAr}
                                    variant="outlined"
                                    sx={{ p: 1 }}
                                />
                            </FlexBetween>
                        </Typography>
                        <Box>
                            <FlexBetween>
                                <Typography variant="h5" sx={{ pr: 1 }}>
                                    <FlexBetween>
                                        < WatchLaterIcon sx={{color: 'gray'}}/>
                                        <span style={{ paddingRight: '4px' }}>قبل يومان</span>
                                    </FlexBetween>
                                </Typography>
                            </FlexBetween>
                        </Box>
                        <br />
                        <Typography variant="body1" color="text.secondary" sx={{ width: '85%', display: 'grid', margin: 'auto' }}>
                            {watch.strComment}
                        </Typography>
                        <br />
                        <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
                            <img
                                src={watch.imageData ? `data:image/jpg;base64,${watch.imageData}` : "https://via.placeholder.com/900x400"}
                                alt={`Image for complaint ${watch.intComplaintId}`}
                                style={{ flex: 1, objectFit: 'cover', borderRadius: '25px', width: "90%", display: 'grid', marginLeft: 'auto', marginRight: 'auto' }}
                            />
                            <FlexBetween>
                                <div style={{ paddingRight: '36px', marginTop: '13px' }}>
                                    <FlexBetween>
                                        <FavoriteIcon />
                                        <span style={{ paddingRight: '5px' }}>{watch.intVotersCount}</span>
                                    </FlexBetween>
                                </div>
                                <Typography variant="h4" sx={{ pl: 8, paddingTop: 3, color: '#18AAC9' }}> ش. المدينة المنورة, عمان</Typography>
                            </FlexBetween>
                        </div>
                    </CardContent>
                </Card>
            ))}
            <br />
        </Box>
    )
}


export default ShowWatchlist;