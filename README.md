# Cryptopals

This is Swift implementation of cryptography challenges at https://cryptopals.com/. My attempt is heavily influenced by two repos: 
* https://github.com/stripedpajamas/cryptopals/
* https://github.com/lt/php-cryptopals


## Progress

- [x] **Set 1: Basics**
  - [x] [1. Convert hex to base64](Sources/Cryptopals/Set1/Challenge1.swift)
  - [x] [2. Fixed XOR](Sources/Cryptopals/Set1/Challenge2.swift)
  - [x] [3. Single-byte XOR cipher](Sources/Cryptopals/Set1/Challenge3.swift)
  - [x] [4. Detect single-character XOR](Sources/Cryptopals/Set1/Challenge4.swift)
  - [x] [5. Implement repeating-key XOR](Sources/Cryptopals/Set1/Challenge5.swift)
  - [x] [6. Break repeating-key XOR](Sources/Cryptopals/Set1/Challenge6.swift)
  - [x] [7. AES in ECB mode](Sources/Cryptopals/Set1/Challenge7.swift)
  - [x] [8. Detect AES in ECB mode](Sources/Cryptopals/Set1/Challenge8.swift)
- [x] **Set 2: Block crypto**
  - [x] [9. Implement PKCS#7 padding](Sources/Cryptopals/Set2/Challenge9.swift)
  - [x] [10. Implement CBC mode](Sources/Cryptopals/Set2/Challenge10.swift)
  - [x] [11. An ECB/CBC detection oracle](Sources/Cryptopals/Set2/Challenge11.swift)
  - [x] [12. Byte-at-a-time ECB decryption (Simple)](Sources/Cryptopals/Set2/Challenge12.swift)
  - [x] [13. ECB cut-and-paste](Sources/Cryptopals/Set2/Challenge13.swift)
  - [x] [14. Byte-at-a-time ECB decryption (Harder)](Sources/Cryptopals/Set2/Challenge14.swift)
  - [x] [15. PKCS#7 padding validation](Sources/Cryptopals/Set2/Challenge15.swift)
  - [x] [16. CBC bitflipping attacks](Sources/Cryptopals/Set2/Challenge16.swift)
- [ ] **Set 3: Block & stream crypto**
  - [x] [17. The CBC padding oracle](Sources/Cryptopals/Set3/Challenge17.swift)
  - [x] [18. Implement CTR, the stream cipher mode](Sources/Cryptopals/Set3/Challenge18.swift)
  - [x] [19. Break fixed-nonce CTR mode using substitions](Sources/Cryptopals/Set3/Challenge19.swift)
  - [x] [20. Break fixed-nonce CTR statistically](Sources/Cryptopals/Set3/Challenge20.swift)
  - [x] [21. Implement the MT19937 Mersenne Twister RNG](Sources/Cryptopals/Set3/Challenge21.swift)
  - [x] [22. Crack an MT19937 seed](Sources/Cryptopals/Set3/Challenge22.swift)
  - [ ] 23. Clone an MT19937 RNG from its output
  - [ ] 24. Create the MT19937 stream cipher and break it
- [ ] **Set 4: Stream crypto and randomness**
  - [ ] 25. Break "random access read/write" AES CTR
  - [ ] 26. CTR bitflipping
  - [ ] 27. Recover the key from CBC with IV=Key
  - [ ] 28. Implement a SHA-1 keyed MAC
  - [ ] 29. Break a SHA-1 keyed MAC using length extension
  - [ ] 30. Break an MD4 keyed MAC using length extension
  - [ ] 31. Implement and break HMAC-SHA1 with an artificial timing leak
  - [ ] 32. Break HMAC-SHA1 with a slightly less artificial timing leak
- [ ] **Set 5: Diffie-Hellman and friends**
  - [ ] 33. Implement Diffie-Hellman
  - [ ] 34. Implement a MITM key-fixing attack on Diffie-Hellman with parameter injection
  - [ ] 35. Implement DH with negotiated groups, and break with malicious "g" parameters
  - [ ] 36. Implement Secure Remote Password (SRP)
  - [ ] 37. Break SRP with a zero key
  - [ ] 38. Offline dictionary attack on simplified SRP
  - [ ] 39. Implement RSA
  - [ ] 40. Implement an E=3 RSA Broadcast attack
- [ ] **Set 6: RSA and DSA**
  - [ ] 41. Implement unpadded message recovery oracle
  - [ ] 42. Bleichenbacher's e=3 RSA Attack
  - [ ] 43. DSA key recovery from nonce
  - [ ] 44. DSA nonce recovery from repeated nonce
  - [ ] 45. DSA parameter tampering
  - [ ] 46. RSA parity oracle
  - [ ] 47. Bleichenbacher's PKCS 1.5 Padding Oracle (Simple Case)
  - [ ] 48. Bleichenbacher's PKCS 1.5 Padding Oracle (Complete Case)
- [ ] **Set 7: Hashes**
  - [ ] 49. CBC-MAC Message Forgery
  - [ ] 50. Hashing with CBC-MAC
  - [ ] 51. Compression Ratio Side-Channel Attacks
  - [ ] 52. Iterated Hash Function Multicollisions
  - [ ] 53. Kelsey and Schneier's Expandable Messages
  - [ ] 54. Kelsey and Kohno's Nostradamus Attack
  - [ ] 55. MD4 Collisions
  - [ ] 56. RC4 Single-Byte Biases
- [ ] **Set 8: Abstract Algebra**
  - [ ] 57. Diffie-Hellman Revisited: Small Subgroup Confinement
  - [ ] 58. Pollard's Method for Catching Kangaroos
  - [ ] 59. Elliptic Curve Diffie-Hellman and Invalid-Curve Attacks
  - [ ] 60. Single-Coordinate Ladders and Insecure Twists
  - [ ] 61. Duplicate-Signature Key Selection in ECDSA (and RSA)
  - [ ] 62. Key-Recovery Attacks on ECDSA with Biased Nonces
  - [ ] 63. Key-Recovery Attacks on GCM with Repeated Nonces
  - [ ] 64. Key-Recovery Attacks on GCM with a Truncated MAC
