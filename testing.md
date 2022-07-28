## Testing

Machine details:<br />
Processor: Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz<br />
OS: openSUSE Leap 15.2<br />
Kernel: Linux 5.3.18-lp152.106-default<br />
Architecture: x86-64<br />
Memory: 504GB<br />

The dataset: 
 Sample	    |  Dataset source				|  No. of reads	| Read length 
 --------- | --------- | --------- | --------- 
 CBS 2834	|  SRA: SRR1119201 				| 2 x 4.7 M	|	101bp


The test has been performed with the **deafult** parameters reported in [HOWTO](https://github.com/nicolo-tellini/sppComb/blob/main/howto.md).

The performances: 
| STEP | Time | Max.RAM |
| :---:         |     :---:      |          :---: |
| 1   | 5:11 min     | 2.8 GB    |
| 2     | 4 s       | 0.4 GB      |
| 3     | 3:05 min       | 11.4 MB      |
| 4     | 2 s       | 13.3 MB      |

4 THR piped samtools (faster but no full threads control)
| STEP | Time | Max.RAM |
| :---:         |     :---:      |          :---: |
| 1   | 3:18 min     | 3.3 GB    |

4 THR piped samtools (slower but full threads control)
| STEP | Time | Max.RAM |
| :---:         |     :---:      |          :---: |
| 1   | 4:05 min     | 3.3 GB    |

6 THR piped samtools (faster but no full threads control)
| STEP | Time | Max.RAM |
| :---:         |     :---:      |          :---: |
| 1   | 5:11 min     | 2.8 GB    |

6 THR piped samtools (slower but full threads control)
| STEP | Time | Max.RAM |
| :---:         |     :---:      |          :---: |
| 1   | 5:11 min     | 2.8 GB    |

The perfomances have been measured with <code>/usr/bin/time -v</code>.
