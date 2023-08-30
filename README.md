# ezTimeStamp
This Bash script allows you to easily use the Time Stamping Authority (TSA) service provided by FreeTSA.org.

## usage:
```
ezTimeStamp /path/to/file
```

When you run the script to generate a timestamp for a file, the original file never leaves your machine. Instead, the script generates a timestamp query (TSQ) file that contains a cryptographic hash of the original file. This hash is a fixed-size string of characters that uniquely represents the contents of the original file, but does not reveal any information about the file itself.

The TSQ file is then sent to the FreeTSA.org Time Stamping Authority (TSA) service over an encrypted https connection. This ensures that the data exchange is secure and cannot be intercepted or tampered with by third parties. The TSA service uses the information in the TSQ to generate a timestamp response (TSR) that provides proof that the original file existed at a certain point in time.

By only sending the TSQ file, which contains a hash of the original file, rather than the original file itself, your privacy is protected. The TSA service does not receive any information about the contents of the original file, only its hash. This ensures that your data remains private and secure.

## Disclaimer

This script is provided "as is" without any warranty. The author is not responsible for any damage or loss caused by using this script.
