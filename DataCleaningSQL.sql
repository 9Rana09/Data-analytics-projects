---Cleaning data
Select *
from SimpleProject.dbo.NashvilleHousing

---Standardize date format

Select SaleDateConverted, CONVERT(Date,saledate)
from SimpleProject.dbo.NashvilleHousing

Update NashvilleHousing
SET saledate = CONVERT(Date,saledate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,saledate)

---popular property address data

Select *
from SimpleProject.dbo.NashvilleHousing
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from SimpleProject.dbo.NashvilleHousing a
JOIN SimpleProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---Checking for NULL and populating

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from SimpleProject.dbo.NashvilleHousing a
JOIN SimpleProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


---Breaking out address into (address, city, state)

Select PropertyAddress
from SimpleProject.dbo.NashvilleHousing
---order by ParcelID

SELECT
SUBSTRING(Propertyaddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(Propertyaddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

from SimpleProject.dbo.NashvilleHousing 

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
from SimpleProject.dbo.NashvilleHousing







SELECT OwnerAddress
from SimpleProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)	
from SimpleProject.dbo.NashvilleHousing

 

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
from SimpleProject.dbo.NashvilleHousing

 


 ---Change y to yes and n to no in "sold as vacant" field

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
from SimpleProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE  when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'NO'
		else SoldAsVacant
		END
		
from SimpleProject.dbo.NashvilleHousing



Update NashvilleHousing
SET SoldAsVacant = CASE  when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'NO'
		else SoldAsVacant
		END



---remove duplicates data

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
					
from SimpleProject.dbo.NashvilleHousing
)
Select * 
From RowNumCTE
Where row_num > 1
order by PropertyAddress



Select *
from SimpleProject.dbo.NashvilleHousing



---delete unused columns



Select *
from SimpleProject.dbo.NashvilleHousing


ALTER TABLE simpleproject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE simpleproject.dbo.NashvilleHousing
DROP COLUMN SaleDate
