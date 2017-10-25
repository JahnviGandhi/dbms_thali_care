ALTER TABLE Transfusion_Cycle_Details
ALTER COLUMN Updated_By varchar(50) NULL;

ALTER TABLE Medication_Cycle_Details
ADD Updated_By varchar(50) NULL;