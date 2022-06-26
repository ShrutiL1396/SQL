-- Data Cleaning and Analysis in SQL

select * 
from Portfolio_Project.dbo.Nashville_2;

-- Standardise column in appropriate date format

select SaleDate
from Portfolio_Project.dbo.Nashville_2;

select SaleDate, CONVERT(Date,SaleDate) as 'Date'
from Portfolio_Project.dbo.Nashville_2;

-- Add column with refined date
alter table Portfolio_Project.dbo.Nashville_2
add Sale_Date_Converted date;

update Portfolio_Project.dbo.Nashville_2
set Sale_Date_Converted = CONVERT(Date,SaleDate);

-- Populate Property Address data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, coalesce(a.PropertyAddress, b.PropertyAddress)
from Portfolio_Project.dbo.Nashville_2 a
join Portfolio_Project.dbo.Nashville_2 b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

Update a
set a.PropertyAddress = coalesce(a.PropertyAddress, b.PropertyAddress)
from Portfolio_Project.dbo.Nashville_2 a
join Portfolio_Project.dbo.Nashville_2 b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from Portfolio_Project.dbo.Nashville_2;

alter table Portfolio_Project.dbo.Nashville_2 
add Address nvarchar(150), city nvarchar(50);
 
update Portfolio_Project.dbo.Nashville_2
set Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

update Portfolio_Project.dbo.Nashville_2
set Property_City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));

exec sp_rename 'Nashville_2.city' , 'Property_City', 'COLUMN'; 


EXEC sp_RENAME 'dbo.Nashville_2.Address', 'Property_Address';


-- Split Owner Address into Address, City and State columns

select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from Nashville_2;

alter table Nashville_2
add OwnerSplitAdd nvarchar(150), OwnerSplitCity nvarchar(50), OwnerSplitState nvarchar(10);

update Nashville_2
set OwnerSplitAdd = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

update Nashville_2
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);


-- Update 'Y' and 'N' to Yes and No in "SoldAsVacant" field in table

select SoldAsVacant, count(SoldAsVacant)
from Nashville_2
group by SoldAsVacant;

select SoldAsVacant,
case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from Nashville_2

update Nashville_2
set SoldAsVacant = case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

-- Remove row-level duplicates from table

with Row_Num_Cte as 
(
select *,
ROW_NUMBER() over (
partition by ParcelID,
PropertyAddress, SalePrice, SaleDate, LegalReference
order by UniqueID
)row_num
from Nashville_2
)

delete * 
from Row_Num_Cte
where row_num > 1;


-- Drop unused columns
alter table Nashville_2
drop column OwnerAddress,PropertyAddress, TaxDistrict;

alter table Nashville_2
drop column SaleDate;