import { useTheme } from "@emotion/react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import React, { useState, useEffect } from "react";
import { FlexBetween } from "../../../Common/Components/FlexBetween";
import { Card, CardContent, Typography, IconButton, Box, Chip, SwipeableDrawer, Divider } from "@mui/material";
import RadioButtonCheckedIcon from '@mui/icons-material/RadioButtonChecked';

const GeneralCompDataGrid = ({ data }) => {
    const theme = useTheme();
    const [selectedCard, setSelectedCard] = useState(null);

    const handleCardClick = (card) => {
        setSelectedCard(card);
    };

    const handleCloseDrawer = () => {
        setSelectedCard(null);
    };

    return (
        <Box sx={{ display: "grid", gap: 2, }}>
            {data.map((GC) => (
                <div onClick={() => handleCardClick(GC)} style={{ width: '70%', }}>
                    <Card key={GC.intComplaintId} sx={{ borderRadius: '25px' }}>
                        <CardContent>
                            <Typography variant="h3" component="div">
                                <FlexBetween>
                                    {GC.strUserName}
                                    <Chip
                                        icon={<RadioButtonCheckedIcon />}
                                        color="primary"
                                        label={GC.strStatus}
                                        variant="outlined"
                                        sx={{ p: 1 }}
                                    />
                                </FlexBetween>
                            </Typography>
                            <Typography variant="h5">
                                {GC.strComplaintTypeAr}
                            </Typography>
                            <Typography variant="h4">
                                {GC.strComment}
                            </Typography>
                            <br />
                            <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
                                <img src="https://via.placeholder.com/900x400" alt="Test Image" style={{ flex: 1, objectFit: 'cover' }} />
                            </div>
                        </CardContent>
                    </Card>
                </div>

            ))}

            <SwipeableDrawer
                anchor="right"
                open={selectedCard !== null}
                onClose={handleCloseDrawer}
                sx={{}}
                onOpen={() => { }} // No need to do anything on open
            >
                {selectedCard && (
                    <Box sx={{ height: '100%', width: '25vw', p: 1, bgcolor: '#ede7f6' }}>
                        <Typography variant="h1" sx={{ p: 1, fontFamily: 'sans-serif', color: 'dark', textAlign:'center' }}> معلومات المشكلة</Typography>
                        <br />
                        <Divider />
                        <br />
                        <CardContent sx={{ width: '100%', p: 1 }}>
                            <Typography variant="h3" sx={{ direction: 'rtl', color: 'dark' }}>
                                <FlexBetween>
                                    النوع <Chip label={selectedCard.strComplaintTypeAr} color="primary" />
                                </FlexBetween>
                            </Typography>
                            <br />
                            <Divider />
                            <br />
                            <Typography variant="h3" sx={{ direction: 'rtl', color: 'dark' }}>
                                <FlexBetween>
                                    الحالة <Chip label={selectedCard.strStatus === "completed" ? "مقبول" : selectedCard.strStatus} color="primary" />
                                </FlexBetween>
                            </Typography>
                            <br />
                            <Divider />
                            <br />
                            <Typography variant="h3" sx={{ direction: 'rtl', color: 'dark' }}>
                                <FlexBetween>
                                    تاريخ الانشاء <Chip label={selectedCard.dtmDateCreated} color="primary" />
                                </FlexBetween>
                            </Typography>
                            <br />
                            <Divider />
                            <br />
                            <Typography variant="h3" sx={{ direction: 'rtl', color: 'dark' }}>
                                <FlexBetween>
                                    تاريخ الاتتهاء <Chip label={selectedCard.dtmDateFinished} color="primary" />
                                </FlexBetween>
                            </Typography>
                            <br />
                            <Divider />
                            <br />
                        </CardContent>
                    </Box>
                )}
            </SwipeableDrawer>

        </Box>
    )
}

export default GeneralCompDataGrid;