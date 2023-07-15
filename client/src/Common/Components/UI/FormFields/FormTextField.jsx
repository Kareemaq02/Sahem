import React from "react";

// Third party
import { Controller, useFormContext } from "react-hook-form";

// Mui
import { TextField, InputAdornment } from "@mui/material";

const FormTextField = (props) => {
  const { control } = useFormContext();

  return (
    <Controller
      name={props.name}
      control={control}
      render={({
        field: { onChange, value },
        fieldState: { error },
        formState,
      }) => (
        <TextField
          fullWidth
          placeholder={props.label}
          onChange={onChange}
          value={value || ""}
          type={props.type || "text"}
          error={error ? true : false}
          helperText={error ? error.message : null}
          InputProps={
            (props.endIcon && {
              endAdornment: (
                <InputAdornment position="end">{props.endIcon}</InputAdornment>
              ),
            }) ||
            (props.startIcon && {
              startAdornment: (
                <InputAdornment position="start">
                  {props.startIcon}
                </InputAdornment>
              ),
            })
          }
        />
      )}
    />
  );
};

export default FormTextField;
