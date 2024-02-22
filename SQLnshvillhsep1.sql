select * from
nshvillhse

--converting into date format

select SaleDate,CONVERT(Date,SaleDate)
from nshvillhse

alter table nshvillhse
add stdsale_date date;

update nshvillhse
set stdsale_date = CONVERT(Date,SaleDate)

--checking duplicates

select *
from nshvillhse as a
join nshvillhse as b
on
a.ParcelID=b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]

--querying where the property address is null

select  a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress
from nshvillhse as a
join nshvillhse as b
on
a.ParcelID=b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--adding the addrress by parcelid
select  a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from nshvillhse as a
join nshvillhse as b
on
a.ParcelID=b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--breaking out the address data
select PropertyAddress,PARSENAME(replace(PropertyAddress,',','.'),2)
from nshvillhse

select PARSENAME(replace(PropertyAddress,',','.'),1)
from
nshvillhse


alter table nshvillhse
add  pro_address nvarchar(300);

update nshvillhse
set pro_address= PARSENAME(replace(PropertyAddress,',','.'),2)

alter table nshvillhse
add  pro_city nvarchar(300);

update nshvillhse
set pro_city=PARSENAME(replace(PropertyAddress,',','.'),1)


alter table nshvillhse
add own_add nvarchar(300)

update nshvillhse
set own_add=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table nshvillhse
add own_city nvarchar(300)

update nshvillhse
set own_city=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table nshvillhse
add own_st nvarchar(300)

update nshvillhse
set own_st=PARSENAME(replace(OwnerAddress,',','.'),1)

--change Yes and No to Y /N in soldasvacant column

select distinct(SoldAsVacant),count(SoldAsVacant)
from
nshvillhse
group by SoldAsVacant


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from nshvillhse


update nshvillhse
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end

--removing duplicates
with rownumcte as(
select *,ROW_NUMBER() over ( partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueID) as rnum
from
nshvillhse
)
delete from rownumcte
where rnum > 1


--delete unused columns

alter table nshvillhse
drop column PropertyAddress,SaleDate,OwnerAddress









