ALTER TABLE Patient_Details
ADD Age int not null
CHECK (Age < 100);
