/*
Cleaning Data in SQL Queries
*/

Select *
From [Portfolio Project ]..JerseyHousing

--Standardizing Date format

Select SaleDate, CONVERT(Date,SaleDate)
From [Portfolio Project ]..JerseyHousing

Update JerseyHousing
SET SaleDate= CONVERT(Date,SaleDate)

ALTER TABLE JerseyHousing
Add SaleDateConverted Date;

Update JerseyHousing
SET SaleDateConverted= CONVERT(Date,SaleDate)

Select SaleDateConverted
From [Portfolio Project ]..JerseyHousing

--Populate Property Address Data.

Select PropertyAddress
From [Portfolio Project ]..JerseyHousing

Select PropertyAddress
From [Portfolio Project ]..JerseyHousing
where propertyaddress is null

Select *
From [Portfolio Project ]..JerseyHousing
--where propertyaddress is null
order by 2

Select A.ParcelID,A.PropertyAddress, B.ParcelID, B.PropertyAddress
From [Portfolio Project ]..JerseyHousing A
JOIN [Portfolio Project ]..JerseyHousing B
	ON A. ParcelID= B.ParcelID
	And A.[UniqueID ] <> B.[UniqueID ]

Select A.ParcelID,A.PropertyAddress, B.ParcelID, B.PropertyAddress
From [Portfolio Project ]..JerseyHousing A
JOIN [Portfolio Project ]..JerseyHousing B
	ON A. ParcelID= B.ParcelID
	And A.[UniqueID ] <> B.[UniqueID ]
	Where A.PropertyAddress is Null

Select A.ParcelID,A.PropertyAddress, B.ParcelID, B.PropertyAddress,ISNULL(A.PropertyAddress,B.PropertyAddress)
From [Portfolio Project ]..JerseyHousing A
JOIN [Portfolio Project ]..JerseyHousing B
	ON A. ParcelID= B.ParcelID
	And A.[UniqueID ] <> B.[UniqueID ]
	Where A.PropertyAddress is Null

Update A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
	From [Portfolio Project ]..JerseyHousing A
JOIN [Portfolio Project ]..JerseyHousing B
	ON A. ParcelID= B.ParcelID
	And A.[UniqueID ] <> B.[UniqueID ]
	Where A.PropertyAddress is Null

--Rerun to confirm if null address has been populated.

Select A.ParcelID,A.PropertyAddress, B.ParcelID, B.PropertyAddress,ISNULL(A.PropertyAddress,B.PropertyAddress)
From [Portfolio Project ]..JerseyHousing A
JOIN [Portfolio Project ]..JerseyHousing B
	ON A. ParcelID= B.ParcelID
	And A.[UniqueID ] <> B.[UniqueID ]
	Where A.PropertyAddress is Null
--

--Breaking Address into individual columns (Address,City,State).

Select PropertyAddress
From [Portfolio Project ]..JerseyHousing
Order by ParcelID

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) As Address,
CHARINDEX(',',PropertyAddress)
From [Portfolio Project ]..JerseyHousing

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Address
From [Portfolio Project ]..JerseyHousing

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) As City
From [Portfolio Project ]..JerseyHousing

ALTER TABLE JerseyHousing
Add PropertySplitAddress nvarchar (255);

Update JerseyHousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE JerseyHousing
Add PropertySplitCity nvarchar (255);

Update JerseyHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))

Select *
From [Portfolio Project ]..JerseyHousing

--Breaking Down Owner Address

Select OwnerAddress
From [Portfolio Project ]..JerseyHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.') ,3) As Address,
PARSENAME(REPLACE(OwnerAddress,',','.') ,2) As City,
PARSENAME(REPLACE(OwnerAddress,',','.') ,1) As State
From [Portfolio Project ]..JerseyHousing

ALTER TABLE JerseyHousing
Add OwnerSplitAddress nvarchar (255);

Update JerseyHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)

ALTER TABLE JerseyHousing
Add OwnerSplitCity nvarchar (255);

Update JerseyHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE JerseyHousing
Add OwnerSplitState nvarchar (255);

Update JerseyHousing
SET  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

Select *
From [Portfolio Project ]..JerseyHousing

--Change Y to Yes and N to No on SoldAsVacant Column..

Select SoldAsVacant
From [Portfolio Project ]..JerseyHousing

Select Distinct(SoldAsVacant)
From [Portfolio Project ]..JerseyHousing

Select Distinct(SoldAsVacant), Count (SoldAsVacant)
From [Portfolio Project ]..JerseyHousing
Group by SoldAsVacant
Order by 2

Select	SoldAsVacant,
 Case	When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End As SoldAsVacantNew
From [Portfolio Project ]..JerseyHousing


Update JerseyHousing
SET SoldAsVacant =
 Case	When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End 


--Remove Duplicates

Select *,
		ROW_NUMBER() Over (
		Partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order by UniqueID
					) row_num
From [Portfolio Project ]..JerseyHousing
order by ParcelID

With RowNumCTE As (
Select *,
		ROW_NUMBER() Over (
		Partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order by UniqueID
					) row_num
From [Portfolio Project ]..JerseyHousing
)
Select *
From RowNumCTE
where row_num > 1
order by ParcelID

--Delete Duplicate

With RowNumCTE As (
Select *,
		ROW_NUMBER() Over (
		Partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order by UniqueID
					) row_num
From [Portfolio Project ]..JerseyHousing
)
Delete
From RowNumCTE
where row_num > 1


--Deleting Unused Columns
Select *
From [Portfolio Project ]..JerseyHousing

Alter Table [Portfolio Project ]..JerseyHousing
Drop Column OwnerAddress,PropertyAddress

Alter Table [Portfolio Project ]..JerseyHousing
Drop Column SaleDate

Select *
From [Portfolio Project ]..JerseyHousing