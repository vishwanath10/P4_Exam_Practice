create master key encryption by password = 'Test@123';

create certificate my_certificate with subject = 'Subject'

create SYMMETRIC KEY Symm_key WITH ALGORITHM = AES_256 
ENCRYPTION BY CERTIFICATE my_certificate



create table dbo.test
(
id varbinary(128) 
)


open symmetric key Symm_key
decryption by certificate my_certificate

insert into dbo.test values (ENCRYPTBYKEY(Key_guid('Symm_key'), '1234'));

close  symmetric key Symm_key

open symmetric key Symm_key
decryption by certificate my_certificate

select CONVERT(VARCHAR(100), DECRYPTBYKEY(id)) from dbo.test

close  symmetric key Symm_key