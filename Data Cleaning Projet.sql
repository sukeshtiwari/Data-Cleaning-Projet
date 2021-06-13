-- Cleaning Data in SQL Queries


SELECT *
FROM PortfolioProject.dbo.[Nashville Housing ] 



-- Standardize Date Format


SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.[Nashville Housing ] 

UPDATE [Nashville Housing ]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE[Nashville Housing ]  
ADD SaleDateConverted date;

UPDATE [Nashville Housing ]
SET SaleDateConverted = CONVERT(Date,SaleDate)




-- Populate property Address Data


SELECT *
FROM PortfolioProject.dbo.[Nashville Housing ] 
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT A.ParcelID , A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM PortfolioProject.dbo.[Nashville Housing ] A
JOIN PortfolioProject.dbo.[Nashville Housing ] B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM PortfolioProject.dbo.[Nashville Housing ] A
JOIN PortfolioProject.dbo.[Nashville Housing ] B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL



-- Breaking Out Address into Individual Columns (Address, City, State)



SELECT PropertyAddress
FROM PortfolioProject.dbo.[Nashville Housing ] 
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
,  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.[Nashville Housing ] 


ALTER TABLE[Nashville Housing ]  
ADD PropertySplitAddress NVARCHAR(255);

UPDATE [Nashville Housing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE[Nashville Housing ]  
ADD PropertySplitCity NVARCHAR(255);

UPDATE [Nashville Housing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))


SELECT *
FROM PortfolioProject.dbo.[Nashville Housing ]





SELECT OwnerAddress
FROM PortfolioProject.dbo.[Nashville Housing ]





SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
FROM PortfolioProject.dbo.[Nashville Housing ]




ALTER TABLE[Nashville Housing ]  
ADD OnwerSplitAddress NVARCHAR(255);

UPDATE [Nashville Housing ]
SET PropertySplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)


ALTER TABLE[Nashville Housing ]  
ADD OnwerSplitCity NVARCHAR(255);

UPDATE [Nashville Housing ]
SET OnwerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)



ALTER TABLE[Nashville Housing ]  
ADD OnwerSplitState NVARCHAR(255);

UPDATE [Nashville Housing ]
SET OnwerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)


-- Change Y and N to YES and NO in "Sold as Vacent"


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.[Nashville Housing ]
GROUP BY SoldAsVacant
ORDER BY 2






SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM PortfolioProject.dbo.[Nashville Housing ]


UPDATE [Nashville Housing ]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END






-- Remove Duplicates


WITH rownumCTE as (
SELECT*,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
                 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num


 FROM PortfolioProject.dbo.[Nashville Housing ]
 --ORDER BY ParcelID
 )

 SELECT*
 FROM rownumCTE
 WHERE row_num > 1
ORDER BY PropertyAddress







-- Delete unused columns



SELECT*
FROM PortfolioProject.dbo.[Nashville Housing ]



ALTER TABLE PortfolioProject.dbo.[Nashville Housing ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.[Nashville Housing ]
DROP COLUMN SaleDate







 SELECT*
 FROM PortfolioProject.dbo.[Nashville Housing ]




 







