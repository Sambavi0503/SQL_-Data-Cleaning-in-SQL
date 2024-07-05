select * from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

select top(100)[uniqueID] from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

---/* SQL DATA CLEANING using Nashville housing prices database */

select * from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

--Converting sale date format

select saledate, convert(date,saledate) from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

alter table dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
add salesdateconv date

update dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
set salesdateconv=convert(date,saledate)

---Removing null from property address

select * from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
where PropertyAddress is Null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)] a
join dbo.[Nashville Housing Data for Data Cleaning (reuploaded)] b
on a.ParcelID=b.ParcelID
and a.[UniqueID] <> b.[uniqueid]
where a.propertyaddress is null

update a
set a.propertyaddress=isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)] a
join dbo.[Nashville Housing Data for Data Cleaning (reuploaded)] b
on a.ParcelID=b.ParcelID
and a.[UniqueID] <> b.[uniqueid]
where a.propertyaddress is null

select PropertyAddress from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
where PropertyAddress is null


--Breaking property address into address, city, state

select propertyaddress from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

alter table dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
add propertysplitaddress nvarchar(255)

update dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
set propertysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

alter table dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
add propertysplitcity nvarchar(255)

update dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
set propertysplitcity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

--Breaking down Owner address

select owneraddress from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

alter table dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
add ownersplitaddress nvarchar(255)

update dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
set ownersplitaddress= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

alter table dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
add ownersplitcity nvarchar(255) 

update dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
set ownersplitcity=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

alter table dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
add ownersplitstate nvarchar(255) 

update dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
set ownersplitstate=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

---Convert 'SoldAsVacant' column to Yes/No 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
Group by SoldAsVacant
order by 2

select  distinct(SoldAsVacant) from dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = '1' THEN 'Yes'
	   When SoldAsVacant = '0' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

--remove duplicates
select *,
row_number()over(
PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) as row_num
From dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
order by row_num DESC

WITH ROWNUMCTE AS(
select *,
row_number()over(
PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) as row_num
From dbo.[Nashville Housing Data for Data Cleaning (reuploaded)])
DELETE FROM ROWNUMCTE
Where row_num > 1
--Order by PropertyAddress

WITH ROWNUMCTE AS(
select *,
row_number()over(
PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) as row_num
From dbo.[Nashville Housing Data for Data Cleaning (reuploaded)])
SELECT * FROM ROWNUMCTE
Where row_num > 1
Order by PropertyAddress

--DELETING UNNECESSARY COLUMNS
SELECT * FROM dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
drop column  PropertyAddress,OwnerAddress,TaxDistrict

SELECT * FROM dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]

alter table dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]
drop column saledate 

SELECT * FROM dbo.[Nashville Housing Data for Data Cleaning (reuploaded)]