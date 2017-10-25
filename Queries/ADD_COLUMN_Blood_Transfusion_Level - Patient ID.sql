ALTER TABLE Blood_Transfusion_Level
ADD Patient_ID int NOT NULL
FOREIGN KEY (Patient_ID) REFERENCES Patient_Details(Patient_ID);


