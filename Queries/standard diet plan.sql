use Thali_Care_Database

select * from Standard_Nutrition_Level;

alter table standard_diet_plan_details
add Calcium_Products varchar(200);

alter table standard_diet_plan_details
add VitaminD_Products varchar(200);

alter table standard_diet_plan_details
add VitaminC_Products varchar(200);

alter table standard_diet_plan_details
add VitaminE_Products varchar(200);

alter table standard_diet_plan_details
add Iron_Products varchar(200);

alter table standard_diet_plan_details
add Glucose_Products varchar(200);

select * from Standard_Diet_Plan_Details