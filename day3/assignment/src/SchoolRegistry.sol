// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IERC20{
    function transfer(address _to, uint256 _value) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

contract SchoolRegistry {
    IERC20 public paymentToken;
    struct StudentDetails{
        uint  id;
        string student_fullname;
        string gender;
        uint level; 
        uint fees;
        bool paymentStatus ;
        uint timeStamp;
        bool suspended;
    }
//  staff struct
    struct StaffDetails {
        uint  id;
        string staff_fullname;
        string gender;
        address staffAddress;
        bool paymentStatus ;
        bool suspended;

    }

    // mapping (address => StudentDetails) student;
    //  STAFF_SALARY;
     uint  constant STAFF_SALARY  = 5000;

    mapping(address => uint) _balances;
    mapping (address => uint) _staffBalance;
    mapping(uint => uint) studentFees;
    mapping (uint => StudentDetails) students;
    mapping  (address => uint) public  addressToStudentId;
        mapping  (address => uint) public  addressToStaffId;


    // addressToStudentId[msg.sender] =id;

    constructor (address _tokenAddress){
        studentFees[100] =200000000000000000;
        studentFees[200] =400000000000000000;
        studentFees[300] =500000000000000000;
        studentFees[400] =500000000000000000;
        studentFees[500] =800000000000000000;


             paymentToken = IERC20(_tokenAddress);
             user =msg.sender;
    }
    event studentPaymentReceived(string _name, uint _level);
    event staffPaid(string _name);
    event addedNewStaff(string _name);

    StudentDetails [] public studentDetails;
    StaffDetails [] public staffDetails;

    // to add new student
    // address _tokenAddress;
    uint256 studentId ;
    address user =msg.sender;
    //    user = msg.sender;
    function addStudent(string memory _studentname, string memory _gender, uint _level) external{
       
        studentId = studentId + 1;
        require(addressToStudentId[msg.sender] ==0, "A student has already registered with this address");
        require(_level == 100 || _level == 200 || _level == 300|| _level == 400 , "Kindly input a valid level, no fee specified for this level");
        // require(_studentname && _gender && _level, "Kindly input ful details");

        uint256 fee = studentFees[_level];

        require(fee > 0, "Fee not set for this level");
        bool success =paymentToken.transferFrom(msg.sender, address(this), fee);
        require(success, "Payment failed");

        StudentDetails memory student =
        (StudentDetails ({
            id: studentId,
            student_fullname:_studentname,
            gender:_gender,
            level:_level, 
            fees:fee, 
            paymentStatus:true,
            timeStamp: block.timestamp, 
            suspended:false
            })); 
        studentDetails.push(student);
        emit studentPaymentReceived(_studentname, _level);
         }

// to add new staff
uint staffId;
        function addStaff(address _staffAddress, string memory _staffname, string memory _gender) external{
        staffId = staffId + 1;
        require(_staffAddress != address(0));
        require(addressToStaffId[_staffAddress] ==0, "This address already exist");
        StaffDetails memory staff =(StaffDetails({id: staffId, staffAddress: _staffAddress, staff_fullname : _staffname, 
        gender:_gender,paymentStatus:false,
                    suspended:false
}));
        staffDetails.push(staff);

        emit addedNewStaff(_staffname);

    }

    //     function receiveStudentPayment(address)external {
    // }
 function getStudentById(uint256 _id) public view returns (StudentDetails memory) {
        return studentDetails[_id];
    }
// to get all students{}
function getAllStudent()external view returns(StudentDetails [] memory){
     return studentDetails;
}

// to get all staff;

function getStaff()external view returns(StaffDetails [] memory){
     return staffDetails;
}

// to pay staff
    // uint[] allStaffAccount ;
    function payStaff(uint256 _id,
     string memory _staffname)external {
        for(uint256 i; i >= staffDetails.length; i++){
        if(staffDetails[i].id == _id) {
                require(staffDetails[i].suspended != false, "Staff has been suspended");
    require(staffDetails[i].paymentStatus == false, "Staff has been paid");
        require(staffDetails[i].staffAddress != address(0), "Can't make payment to address zero");
        require(paymentToken.balanceOf(address(this)) >= STAFF_SALARY ,"Insufficient fund");
       
        address StaffAccount =staffDetails[i].staffAddress;
        paymentToken.transfer(StaffAccount, STAFF_SALARY);
        }
    
        emit staffPaid(_staffname);
            }
        }

        function suspendStaff(uint _id) external  returns(bool){
        for(uint i; i >= staffDetails.length; i++){
                    if(staffDetails[i].id == _id) {
                        staffDetails[i].suspended =true;
                    }
        }}

        // to remove student
      function suspendStudent(uint _id) external  returns(bool){
        for(uint i; i >= studentDetails.length; i++){
                    if(studentDetails[i].id == _id) {
                        studentDetails[i].suspended =true;
                    }
        }

        return true;
        }

        
         function removeStudent(uint _id) external  returns(bool){
        for(uint i; i >= studentDetails.length; i++){
                    if(studentDetails[i].id == _id) {
                        studentDetails[i] =studentDetails[studentDetails.length - 1];
                        studentDetails.pop();
                    }
        }
                return true;

        }
        // return true;
    
}
