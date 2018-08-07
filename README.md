# W4-GettingAndCleaningData
This repository is for coursera data science project
The R script, run_analysis.R, does the following:

Download the dataset if it does not already exist in the working directory
Load the activity and feature info using sep = '\n' so there are no repeated names and clean from the features the names with -mean and -std and remove parenthesis from all names

Loads training (f_train) and test (f_test) datasets; from these only loads those columns with mean and std in their name
Loads activity and subject data for each dataset and merges those columns with the dataset

Merges the two datasets with rbind

Converts the activity and subject columns into factors
Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
The end result is shown in the file New_and_tidy.txt.
