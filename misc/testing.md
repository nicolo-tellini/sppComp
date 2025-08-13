## Testing

Machine details:<br />
Processor: Intel i9-9900K (16) @ 5.000GHz<br />
OS: Ubuntu 20.04.6 LTS<br />
Kernel: 5.15.0-151-generic<br />
Architecture: x86_64<br />
Memory: 31GB<br />

The dataset: 
 Sample	    |  Dataset source				|  No. of reads	| Read length 
 --------- | --------- | --------- | --------- 
 CBS 2834	|  SRA: SRR1119201 				| 2 x 4.7 M	|	101bp

The test has been performed with 2 threads.

The performances with 2 threads: 
| STEP | Time | Max.RAM |
| :---:         |     :---:      |          :---: |
| init  | 0 s     | 0 GB    |
| mapcov     |   1:51 min     | 1.6 GB      |
| Wplot     |   4 s    | 0.1 GB     |

The perfomances have been measured with <code>/usr/bin/time -v</code>.
