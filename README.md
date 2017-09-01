
#	**Bài Kiểm Tra 01**

	
**Bài 1) Viết Script Check OS của dải mạng**


**Giới thiệu về NMAP :** Network exploration tool and security scanner (network mapper) Đây là 1 công cụ cực kì quan trọng của hacker cũng như những nhà quản trị mạng trên thế giới, nó có các tính năng nổi bật như sau:

-   Nmap giúp kiểm tra những dịch vụ nào đang chạy trên server,server đó dùng HĐH gì…

- Kiểm tra xem host nào đang UP 

- Kiểm tra các port nào đang mở 

- Chạy được trên nhiều HĐH.

- Và còn nhiều tính năng khác 

**Các Options phổ biến trên NMAP**

- HOST DISCOVERY: 

```sh
             -sL: List Scan - simply list targets to scan
             -sn: Ping Scan - disable port scan
             -Pn: Treat all hosts as online -- skip host discovery
             -PS/PA/PU/PY[portlist]: TCP SYN/ACK, UDP or SCTP discovery to given ports
             -PE/PP/PM: ICMP echo, timestamp, and netmask request discovery probes
             -PO[protocol list]: IP Protocol Ping
             -n/-R: Never do DNS resolution/Always resolve [default: sometimes]
             --dns-servers <serv1[,serv2],...>: Specify custom DNS servers
             --system-dns: Use OS

```

- SCAN TECHNIQUES:


```sh
             -sS/sT/sA/sW/sM: TCP SYN/Connect()/ACK/Window/Maimon scans
             -sU: UDP Scan
             -sN/sF/sX: TCP Null, FIN, and Xmas scans
             --scanflags <flags>: Customize TCP scan flags
             -sI <zombie host[:probeport]>: Idle scan
             -sY/sZ: SCTP INIT/COOKIE-ECHO scans
             -sO: IP protocol scan
             -b <FTP relay host>: FTP bounce scan
```

- PORT SPECIFICATION AND SCAN ORDER:

```sh
             -p <port ranges>: Only scan specified ports
               Ex: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9
             --exclude-ports <port ranges>: Exclude the specified ports from scanning
             -F: Fast mode - Scan fewer ports than the default scan
             -r: Scan ports consecutively - don't randomize
             --top-ports <number>: Scan <number> most common ports
             --port-ratio <ratio>: Scan ports more common than <ratio>
```

- OS DETECTION:

```sh
             -O: Enable OS detection
             --osscan-limit: Limit OS detection to promising targets
             --osscan-guess: Guess OS more aggressively
```
- OUTPUT: 

```sh
            -oN/-oX/-oS/-oG <file>: Output scan in normal, XML, s|<rIpt kIddi3,
                and Grepable format, respectively, to the given filename.
             -oA <basename>: Output in the three major formats at once
             -v: Increase verbosity level (use -vv or more for greater effect)
             -d: Increase debugging level (use -dd or more for greater effect)
             --reason: Display the reason a port is in a particular state
             --open: Only show open (or possibly open) ports
             --packet-trace: Show all packets sent and received
             --iflist: Print host interfaces and routes (for debugging)
             --append-output: Append to rather than clobber specified output files
             --resume <filename>: Resume an aborted scan
             --stylesheet <path/URL>: XSL stylesheet to transform XML output to HTML
             --webxml: Reference stylesheet from Nmap.Org for more portable XML
             --no-stylesheet: Prevent associating of XSL stylesheet w/XML output

```

NMAP còn rất nhiều Options rất hữu ích nhưng trong khuôn khổ bản báo cáo này em chỉ giới thiệu những Options phổ biến, ta có thể tham khảo thêm tại Manual Page của NMAP.

**Sử dụng NMAP để xử lý bài toán**

- Hướng 1: Sử dụng options  **-sS**  của NMAP để quét các host đang mở và quét trạng thái của các cổng cần kiểm tra ở đây là cổng: 22 và 3389. Câu lệnh như sau:


```sh
sudo nmap -sS -p 22,3389 192.168.61.0/24 > testxx.txt
```
Ta thu được định dạng trong file testxx.txt như sau

```sh
Nmap scan report for 192.168.61.10
Host is up (0.0067s latency).
PORT     STATE  SERVICE
22/tcp   open   ssh
3389/tcp closed ms-wbt-server
MAC Address: 54:78:1A:0F:1E:41 (Cisco Systems)

```
Sau khi thu được định dạng trên mục tiêu là lọc theo trạng thái các port đang open hoặc close để xem nó sử dụng OS nào nhưng em không có giải pháp nào để lọc được các trường này cho tất cả các host được lưu trong tập tin rất mong nhận được sự chỉ giáo từ anh.

- Hướng 2: Sử dụng option **sn**  trên NMAP để check ra các host đang sống sau đó cũng ghi vào tập tin, sau đó ta lọc lấy địa chỉ IP của các host và sử dụng lệnh nc ( netcut ) để kiểm tra xem từng host có mở cổng 22 hoặc 3389 rồi đưa ra kết luận OS mà nó sử dụng là gì, các câu lệnh này được viết trong Script bai1 e có để ở trên.

 **Bài 2) Kiểm soát định dạng và dung lượng Image**


**Convert file Qcow2 sang định dạng RAW** ta sử dụng câu lệnh sau

```sh
qemu-img convert -f qcow2 -O raw ubuntu-16.04-server-cloudimg-amd64-disk1.img hannv1.raw
```
Xem thông tin file Qcow2 ban đầu:

```sh
root@masteransible-hannv:~# qemu-img info ubuntu-16.04-server-cloudimg-amd64-disk1.img 
image: ubuntu-16.04-server-cloudimg-amd64-disk1.img
file format: qcow2
virtual size: 2.2G (2361393152 bytes)
disk size: 275M
cluster_size: 65536
Format specific information:
    compat: 0.10
    refcount bits: 16

```
Xem thông tin file raw sau khi convert:

```sh
root@masteransible-hannv:~# qemu-img info hannv1.raw 
image: hannv1.raw
file format: raw
virtual size: 2.2G (2361393152 bytes)
disk size: 903M
```
Có thể thấy định dạng file Qcow2 được nén đi khá nhiều so với định dạng RAW.

**RESIZE IMAGE về mức tối thiểu có thể**

- **Phương án 1** sử dụng tools guestfish, các bước thực hiện như sau 

Sau khi convert file Qcow2 sang RAW ta tiến hành khởi động guestfish

```sh
guestfish 
```
nếu chưa có guestfish thì ta cài thêm vào
```sh
apt install libguestfs-tools
```
sau khi đăng nhập vào guestfish ta thực hiện các câu lệnh sau:

```sh
root@masteransible-hannv:~# guestfish 

Welcome to guestfish, the guest filesystem shell for
editing virtual machine filesystems and disk images.

Type: 'help' for help on commands
      'man' to read the manual
      'quit' to quit the shell

><fs> add hannv1.raw
><fs> run
 100% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⟧ --:--
><fs> list-filesystems 
/dev/sda1: ext4
><fs> e2fsck-f /dev/sda1
><fs> resize2fs-size /dev/sda1 1300M
libguestfs: error: resize2fs_size: resize2fs 1.42.13 (17-May-2015)
resize2fs: New size smaller than minimum (348380)
><fs> resize2fs-size /dev/sda1 1400M
><fs> e2fsck-f /dev/sda1 
><fs> list-filesystems 
/dev/sda1: ext4
><fs> quit
```
Có thể thấy ở trên khi resize về 1300M sẽ có thông báo là giảm quá dung lượng tối thiểu, nhưng xét về căn bản thì việc sử dụng Tool này không hoàn toàn thỏa mãn bởi vì ta không thực sự kiểm soát được liệu image có bị lỗi hay không hay khi resize dung lượng Guestfish đã lược bỏ những phần nào của Image. 

- **Phương án 2**: Cách đơn giản nhất để resize image định dạng raw về mức tối thiểu là ta cần Mount tập tin ra thư mục nào đó rồi xóa bỏ những phần mà khi ta xóa không ảnh hưởng đến Image như phần Update....


**Bài 3) Cài đặt tự động ejabberd cho một server sử dụng Ansible + SaltStack**

Các bước cài đặt + Cấu hình Ejabberd, thực hiện cài đặt:

```sh
apt-get install ejabberd
```

Sau đó truy cập theo đường dẫn để cấu hình

```sh
vim /etc/ejabberd/ejebberd.yml
```
Có 2 phần cấu hình ta cần tùy chỉnh, thứ nhất là Host:


```sh
hosts:
  - "vccloud.com"
```

và phần cấu hình user admin:

```sh
acl:
  admin:
    user:
      - "hannv": "vccloud.com"

```
Restart lại service:

```sh
service ejabberd restart 
```
Bước cuối cùng là ta cần tạo 1 tài khoản admin sau đó đăng nhập vào web để quản lý:

```sh
ejabberdctl register hannv vccloud.com 123 
```
Các bước cài đặt và cấu hình căn bản là như vậy và đã được tự động hóa bằng Ansible đã được e up ở trên.

**Chú Ý Quan Trọng** Có một lỗi xảy ra khi ta tự động tiến hành đăng ký 1 tài khoản admin bằng ansible ta thường gặp lỗi, lỗi này xảy ra là do service ejabberd chưa kịp running trên node thì ansible đã ra lệnh cho slave thực hiện register user admin nên xảy ra lỗi vì vậy em đã sử dụng module pause của ansible để tạm dùng trong vòng 6s đợi cho service ejabberd running mới tiến hành register user admin.

**Bài 4)Mở rộng filesystem khi lắp thêm ổ cứng**

Với trường hợp này e sẽ sử dụng LVM

Giới thiệu về LVM: LVM là một phương pháp cho phép ấn định không gian đĩa cứng thành những Logical Volume khiến cho việc thay đổi kích thước trở lên dễ dàng ( so với partition ). Với kỹ thuật Logical Volume Manager (LVM) có thể thay đổi kích thước mà không cần phải sửa lại partition table của OS. Điều này thực sự hữu ích với những trường hợp đã sử dụng hết phần bộ nhớ còn trống của partition và muốn mở rộng dung lượng của nó.
Các khai niệm căn bản:

- **Physical Volume**: Là một cách gọi khác của partition trong kỹ thuật LVM, là những thành phần cơ bản được sử dụng bởi LVM. Một Physical Volume không thể mở rộng ra ngoài phạm vi một ổ đĩa

- **Logical Volume Group**: Nhiều Physical Volume trên những ổ đĩa khác nhau được kết hợp lại thành một Logical Volume Group, với LVM Logical Volume Group được xem như một ổ đĩa ảo.

- **Logical Volumes**: Logical Volume Group được chia nhỏ thành nhiều Logical Volume, mỗi Logical Volume có ý nghĩa tương tự như partition. Nó được dùng cho các mount point và được format với những định dạng khác nhau như ext2, ext3 ... khi dung lượng của Logical Volume được sử dụng hết có thể đưa thêm ổ đĩa mới bổ sung cho Logical Volume Group và do đó tăng được dung lượng của Logical Volume.

**Ưu điểm** Có thể gom nhiều đĩa cứng vật lý lại thành một đĩa ảo dung lượng lớn,Có thể tạo ra các vùng dung lượng lớn nhỏ tuỳ ý. Không để hệ thống bị gián đoạn hoạt động

**Nhược điểm**Các bước cài đặt, cấu hình, thay đổi dung lượng phức tạp và khó khăn,Gây chậm khi khởi động hệ thống với các hệ thống lớn có nhiều LVM,không thể sử dụng với /boot mount point, và LVM chỉ thực hiện được trên các hệ điều hành Linux.






















































