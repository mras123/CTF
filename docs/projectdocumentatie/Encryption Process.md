# Database Encryption

## What is Data Encryption?

Data encryption translates data into another form, or code, so that only people with access to a secret key (formally called a decryption key) or password can read it. Encrypted data is commonly referred to as ciphertext, while unencrypted data is called plaintext. Currently, encryption is one of the most popular and effective data security methods used by organizations. Two main types of data encryption exist - asymmetric encryption, also known as public-key encryption, and symmetric encryption.


## How does database encryption work?

With database encryption, an encryption algorithm transforms data within a database from a readable state into a ciphertext of unreadable characters. With a key generated by the algorithm, a user can decrypt the data and retrieve the usable information as needed. Unlike security methods like antivirus software or password protection, this form of defense is positioned at the level of the data itself. This is crucial because if a system is breached, the data is still only readable for users who have the right encryption keys. In this documentation we will be encrypting and decrypting the table "Secret" and specific the column "info". The column "info" stores and provides the user secrets/passwords.

## Encryption Procedures

We are using the Fernet this is part of the cryptography library for Python. Fernet guarantees that a message encrypted using it cannot be manipulated or read without the key. Fernet is an implementation of symmetric (also known as “secret key”) authenticated cryptography.

### Creating encryption file in Secretsapp

Create a file named "encKey.py" to store the secret key. The encKey variable contains the secret key required for encryption and decryption. Without this key, the data cannot be encrypted or decrypted accurately.

```yaml
encKey = store_here_the_secret_key

```

### Imports in home.py

Import Fernet from the cryptography library:
```yaml
from cryptography.fernet import Fernet

```
This file is utilized to import the encKey variable from another module or file:

```yaml
from .encKey import encKey
```
### Explaining encryption and decryption in home.py

initializes a Fernet cipher suite object named cipher_suite using the encryption key that is stored in the encKey file. This object is now configured to perform encryption and decryption using the AES algorithm with the provided key.

```yaml
# Initialize Fernet with the key
cipher_suite = Fernet(encKey)
```

This line defines a Python function named encrypt_data that takes one parameter, data. This function is designed to encrypt the provided data.

```yaml
# Function to encrypt data
def encrypt_data(data):
    flash(data, 'error')
```
This line encrypts the provided data using the cipher_suite object. The result of the encryption operation is stored in the variable encrypted.
```yaml
  
    encrypted = cipher_suite.encrypt(data.encode())
    return encrypted
```
This line retrieves all the rows (secrets) from the database in the column "info" and stores them in the variable secrets

```yaml
secrets = cursor.fetchall()
```

This line initializes an empty list named decrypted_secrets. This list will store the decrypted secrets.

```yaml
decrypted_secrets = []
```


for secret in secrets:
    secretEnc = secret[2].encode()
    decrypted_secret_info = cipher_suite.decrypt(secretEnc).decode()
    decrypted_secrets.append((secret[0], secret[1], decrypted_secret_info, secret[3]))