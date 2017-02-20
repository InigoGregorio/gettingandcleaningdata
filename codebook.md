Codebook
========

This codebook was generated to explain the data set produced as output using "run\_analysis.R".

Variables description
---------------------

-   subjectid: integer referring to the subject observed
-   activityname: char vector that identifies the activity being performed when the measure was taken
-   featurename: char vector that identifies the measure taken
-   mean: double that captures the mean of the values taken for that measure (feature) in that subject in that activity

Some rows
---------

``` r
load(".Rdata")
head(meandataset)
```

    ##   subjectid       activityname       featurename      mean
    ## 1         1            WALKING tBodyAcc-mean()-X 0.2773308
    ## 2         1   WALKING_UPSTAIRS tBodyAcc-mean()-X 0.2554617
    ## 3         1 WALKING_DOWNSTAIRS tBodyAcc-mean()-X 0.2891883
    ## 4         1            SITTING tBodyAcc-mean()-X 0.2612376
    ## 5         1           STANDING tBodyAcc-mean()-X 0.2789176
    ## 6         1             LAYING tBodyAcc-mean()-X 0.2215982

Summary statistics
------------------

``` r
summary(meandataset)
```

    ##    subjectid    activityname       featurename             mean         
    ##  Min.   : 1.0   Length:11880       Length:11880       Min.   :-0.99767  
    ##  1st Qu.: 8.0   Class :character   Class :character   1st Qu.:-0.96205  
    ##  Median :15.5   Mode  :character   Mode  :character   Median :-0.46989  
    ##  Mean   :15.5                                         Mean   :-0.48436  
    ##  3rd Qu.:23.0                                         3rd Qu.:-0.07836  
    ##  Max.   :30.0                                         Max.   : 0.97451
