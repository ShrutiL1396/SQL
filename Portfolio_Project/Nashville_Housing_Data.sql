/*
Data Cleaning in SQL
*/
use Portfolio_Project;

select *
from Nashville_Housing;


---------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate, CONVERT(Date,SaleDate) 
from Nashville_Housing;

update Nashville_Housing
set SaleDate = CONVERT(Date,SaleDate);

alter table Nashville_Housing
add Sales_Date_Converted Date;

update Nashville_Housing
set Sales_Date_Converted = CONVERT(Date,SaleDate);

select Sales_Date_Converted
from Nashville_Housing;

select * from 
Nashville_Housing

alter table Nashville_Housing
drop column SaleDate;


----------------------------------------------------------------------------------

-- Populate Property Address data

select *
from Nashville_Housing
where PropertyAddress is null
order by ParcelID;


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from Nashville_Housing a
inner join Nashville_Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where b.PropertyAddress is null;

update b
set PropertyAddress = ISNULL(b.PropertyAddress,a.PropertyAddress)
from Nashville_Housing a
inner join Nashville_Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where b.PropertyAddress is null;

-------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select *
from Nashville_Housing
order by [UniqueID ]

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from Nashville_Housing


alter table nashville_housing
add Street_Address nvarchar(255)

alter table nashville_housing
add City nvarchar(255)

update Nashville_Housing 
set Street_Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) from Nashville_Housing;

update Nashville_Housing 
set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) from Nashville_Housing;

select *
from Nashville_Housing;


-----------------------------------------------------------------------------------

-- Update the Ownder Address

select OwnerAddress
from Nashville_Housing;

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as 'Owner_Street',
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as 'Owner_City',
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as 'Owner_State'
from Nashville_Housing


alter table nashville_housing
add Owner_State nvarchar(255)


alter table nashville_housing
add Owner_City nvarchar(255)


alter table nashville_housing
add Owner_Street nvarchar(255)

update Nashville_Housing 
set Owner_State = PARSENAME(REPLACE(OwnerAddress,',','.'),1) from Nashville_Housing;

update Nashville_Housing 
set Owner_City = PARSENAME(REPLACE(OwnerAddress,',','.'),2) from Nashville_Housing;

update Nashville_Housing 
set Owner_Street = PARSENAME(REPLACE(OwnerAddress,',','.'),3) from Nashville_Housing;

select *
from Nashville_Housing;

-------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SoldasVacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from Nashville_Housing
group by SoldAsVacant
order by 2;


select SoldAsVacant,
case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
from Nashville_Housing;

update
Nashville_Housing
set SoldAsVacant = case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end

select *
from Nashville_Housing;


---------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumCte as 
(select *, ROW_NUMBER() over  
		(partition by ParcelID,
					  PropertyAddress,
					  Sales_Date_Converted,
					  SalePrice,
					  LegalReference
					  order by
					  uniqueID) row_num
from
Nashville_Housing)

delete 
from RowNumCte
where row_num > 1;


---------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * 
from Nashville_Housing;

alter table nashville_housing
drop column propertyAddress,OwnerAddress, TaxDistrict

------------
select
OwnerName,sales_date_converted, count(Owner_City) over (partition by Owner_city order by Owner_City )
from
Nashville_Housing