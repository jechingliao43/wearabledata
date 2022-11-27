# wearabledata repo

## README: run_analysis.R

rd: a function that reads the `.txt` file that is input into a dataframe. Scan it into a vector, turn it into a matrix of the designated number of columns and convert it into a dataframe.

label: a function that uses the `mutate` function of `dplyr` package to assign activity label to respective value of activity IDs.

The following two blocks of codes lead the program to the folders where the six `.txt` files are with `setwd` and read the files with `rd` function.

Next, `rbind` is called to merge the training and testing datasets together. The following code block utilizes `read.table` function to export the 561 variable names stored in `features.txt`. The enumerating column gone after nullified and the column names are designated with the character vector into which the remaining column transformed.

Using `cbind` function, the identifier value dataframes of the experiment subjects (`subdata`) and the six different activities (`ydata`) is inserted into the main dataset (`xdata`) as the first two columns with column names `participant_id` and `activity_id`.

The following steps are to extract the `mean` and `std` variables from the 561 variables. With `grep` function, character strings `mean` and `std` are partially matched in the column names and two subsets of the `data` dataset are extracted, subsequently combined together, along with the `participant_id` and `activity_id` columns.

A simple line of code calls the predefined `label` function and completes the assignment of activity labels to the identifiers, creating the `activity_label` column. Then, `arrange` function organize the dataset in the ascending order of `participant_id` and, within each participant, in the ascending order of `activity_id`. Finally, using `gsub`, the column names are modified into a better form that avoids the `-` sign, which could confuse R as a calculation, and the `()` sign, which could make R think a function is called.

Upon till this part, a tidy dataset of the `mean` and `std` variables accompanied with the correct activity labels is produced. To create a second dataframe `group_by` is used first to group the data w.r.t. `participant_id` and, within each participant, w.r.t. `activity_id`. Next, the desired dataset with the mean of every variable for every participant is created with `summarize` applied to `data`, saved into `sumdata`.Specifically, called inside `summarize`, `across` function applies `mean` to all columns except `activity_label`, a `character` column.

After inspecting the column names after `summarize` is applied to them, a `_1` suffix is created on all of them. Therefore, `gsub` is called to fix that. Next, `label` is called again to restore the `activity_label` column. Finally, to point out that all the columns are the mean of the variables from the original tidy dataset, `paste` is used to all the `numeric` columns except the `id` columns to add a `mean_` as prefix of the names.

After constructing all necessary datasets, `rm` is used to clear up other objects in the environment. `write.table` function is called twice to write `data` and `subdata` into `tidy.txt` and `tidy_mean.txt` respectively.
