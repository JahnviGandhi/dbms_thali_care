use Thali_Care_Database;

alter table standard_transfusion_Level 
add Min_Hbf decimal(4,2);

alter table standard_transfusion_Level 
add Max_Hbf decimal(4,2);

alter table standard_transfusion_Level 
add Min_HbA2 decimal(4,2);

alter table standard_transfusion_Level 
add Max_HbA2 decimal(4,2);

alter table standard_transfusion_Level 
add Age_Gender_Parameter_Mapping_ID int Foreign Key references Age_Gender_Parameter_Mapping(Age_Gender_Parameter_Mapping_ID);



alter table Blood_Transfusion_Level 
drop column Min_HB;

alter table Blood_Transfusion_Level 
drop column Min_MCV;

alter table Blood_Transfusion_Level 
drop column Min_MCH;

alter table Blood_Transfusion_Level 
drop column Max_HB;

alter table Blood_Transfusion_Level 
drop column Max_MCV;

alter table Blood_Transfusion_Level 
drop column Max_MCH;

alter table Blood_Transfusion_Level 
drop constraint FK__Blood_Tra__Age_G__40C49C62;

alter table Blood_Transfusion_Level 
drop column Age_Gender_Parameter_Mapping_ID;

alter table Blood_Transfusion_Level 
add Hbf_Required decimal(4,2);

alter table Blood_Transfusion_Level 
add HbA2_Required decimal(4,2);

alter table Blood_Transfusion_Level 
add Transfusion_Level_Id int Foreign Key references Standard_Transfusion_Level(Transfusion_Level_Id);

