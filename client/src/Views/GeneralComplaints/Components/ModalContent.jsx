import React from "react";
import { Card, CardContent, Typography, Chip } from "@mui/material";
import RadioButtonCheckedIcon from '@mui/icons-material/RadioButtonChecked';
import { IconButton } from "@mui/material";
import CloseIcon from "@mui/icons-material/Close";

const ModalContent = ({ data, onClose }) => {
    if (!data) {
        return null;
    }

    return (
        <div>
            <Typography variant="h4">
                {data.strComment}
            </Typography>
            <button onClick={onClose}>Close</button>
        </div>
    );
}


export default ModalContent;
