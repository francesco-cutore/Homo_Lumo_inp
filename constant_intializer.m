function CONSTANTS = constant_intializer(working_dir)
    working_dir = regexprep(working_dir, "\", "/");
    CONSTANTS = dictionary();
    CONSTANTS("Output") = strcat(working_dir, "/Output");
    CONSTANTS("Output_Gaussian") = strcat(working_dir, "/Output_Gaussian");
    CONSTANTS("Functions") = strcat(working_dir, "/Functions"); 
end