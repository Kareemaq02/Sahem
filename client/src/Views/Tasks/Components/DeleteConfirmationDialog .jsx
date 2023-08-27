import React from "react";
import {
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  Button,
} from "@mui/material";

const DeleteConfirmationDialog = ({ open, onClose, onDelete }) => {
  return (
    <Dialog open={open} onClose={onClose}>
      <DialogTitle sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>تاكيد الحذف</DialogTitle>
      <DialogContent>
        <DialogContentText sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
          هل انت متاكد من حذف هذا العمل؟
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose} color="primary" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>
          الغاء
        </Button>
        <Button
          onClick={() => {
            onDelete();
            onClose();
          }}
          color="primary"
          sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}
        >
          حذف
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default DeleteConfirmationDialog;
