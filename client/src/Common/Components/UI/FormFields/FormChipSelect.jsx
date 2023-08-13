// FormSelect.js
import React from "react";
import { Chip, Divider } from "@mui/material";

const FormChipSelect = ({ value, onChange, items }) => {
  const handleChipClick = (item) => {
    // Check if the item is already selected
    const isSelected = value.includes(item.value);

    // Toggle the selected status
    const selectedValues = isSelected
      ? value.filter((val) => val !== item.value)
      : [...value, item.value];

    // Call the onChange prop with the selected values
    onChange(selectedValues);
  };

  return (
    <>
      {items.map((item) => (
        <>
        <Chip
          key={item.value}
          label={item.label}
          color={item.color}
          onClick={() => handleChipClick(item)}
          variant={value.includes(item.value) ? "default" : "outlined"}
          />
          <br/>
          <br/>
          </>     
          ))}
    </>
  );
};

export default FormChipSelect;
