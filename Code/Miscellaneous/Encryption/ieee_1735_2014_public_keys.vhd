`protect version = 2
`protect encrypt_agent = "XILINX"
`protect encrypt_agent_info = "Xilinx Encryption Tool 2017"
`protect begin_commonblock
`protect control error_handling = "delegated"
`protect control decryption = (activity == simulation) ? "false" : "true"
`protect end_commonblock
`protect begin_toolblock
`protect rights_digest_method="sha256"
`protect key_keyowner = "Xilinx", key_keyname= "xilinxt_2019_11", key_method = "rsa", key_public_key
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxB1QBd2miIgdTOsRqKvf
mj1LZ9dX4azjtma2Mpa1XIUePAY/vrmpomNZP1sj+vYE961raAQpEMvX3UUAsryz
B3LokCnu7cOf6wMybP1fgm6JWKr4G9pZxrWIbRrWR3r92E+Kxz8op8eV6RhbmuET
ShK7FG2IqZORnN+YSbQvDYzn6mjC6CFE3nkEUnodLbpQmM96+1ZcNjePc6CS3sP4
2FKQAq1+0k6+XvVaE6lSspNbx3k6s67XmpFkHYm9i/YnrqMOYIeHMOQB2K9D/CkI
WJ3U9rrOW2lBpd8pQK4zFAOWYxYhfMn3GFPeeFOA1Nh7LVF9GoeVcd+h7rqqZ6yA
uwIDAQAB
`protect control xilinx_configuration_visible = "false"
`protect control xilinx_enable_modification = "false"
`protect control xilinx_enable_probing = "false"
`protect control xilinx_enable_bitstream = "true"
`protect control decryption = (xilinx_activity == simulation) ? "true" : "true"
`protect end_toolblock = ""
