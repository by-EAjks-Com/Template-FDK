`pragma protect version = 2
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2017"
`pragma protect begin_commonblock
`pragma protect control error_handling = "delegated"
`pragma protect control decryption = (activity == simulation) ? "false" : "true"
`pragma protect end_commonblock
`pragma protect begin_toolblock
`pragma protect rights_digest_method="sha256"
`pragma protect key_keyowner = "Xilinx", key_keyname= "xilinxt_2019_11", key_method = "rsa", key_public_key
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxB1QBd2miIgdTOsRqKvf
mj1LZ9dX4azjtma2Mpa1XIUePAY/vrmpomNZP1sj+vYE961raAQpEMvX3UUAsryz
B3LokCnu7cOf6wMybP1fgm6JWKr4G9pZxrWIbRrWR3r92E+Kxz8op8eV6RhbmuET
ShK7FG2IqZORnN+YSbQvDYzn6mjC6CFE3nkEUnodLbpQmM96+1ZcNjePc6CS3sP4
2FKQAq1+0k6+XvVaE6lSspNbx3k6s67XmpFkHYm9i/YnrqMOYIeHMOQB2K9D/CkI
WJ3U9rrOW2lBpd8pQK4zFAOWYxYhfMn3GFPeeFOA1Nh7LVF9GoeVcd+h7rqqZ6yA
uwIDAQAB
`pragma protect control xilinx_configuration_visible = "false"
`pragma protect control xilinx_enable_modification = "false"
`pragma protect control xilinx_enable_probing = "false"
`pragma protect control xilinx_enable_bitstream = "true"
`pragma protect control decryption = (xilinx_activity == simulation) ? "true" : "true"
`pragma protect end_toolblock = ""
