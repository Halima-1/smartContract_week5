// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

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
    }
//  staff struct
    struct StaffDetails {
        uint  id;
        string staff_fullname;
        string gender;
        address staffAddress;
        bool paymentStatus ;
    }

    mapping (address => uint) name;
    //  staffSalary;
     uint  constant staffSalary  = 5e18;

    mapping(address => uint) _balances;
    mapping (address => uint) _staffBalance;
    mapping(uint => uint) studentFees;

    constructor (address _tokenAddress){
        studentFees[100] = 2e18;
        studentFees[200] =4e18;
        studentFees[300] =5e18;
        studentFees[400] =5e18;
        studentFees[500] =8e18;

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
    uint256 student_id ;
    address user =msg.sender;
    //    user = msg.sender;
    function addStudent(string memory _studentname, string memory _gender, uint _level) external{
       
        student_id = student_id + 1;

        require(_level == 100 || _level == 200 || _level == 300|| _level == 400 , "iiii");
        // require(_studentname && _gender && _level, "Kindly input ful details");

        // _balances[user].transfer(paym)
        uint256 fee = studentFees[_level];

        require(fee > 0, "Fee not set for this level");
        bool success =paymentToken.transferFrom(user, address(this), fee);
        require(success, "Payment failed");

        StudentDetails memory student =
        (StudentDetails ({id: student_id,student_fullname:_studentname, gender:_gender, level:_level, fees:0, paymentStatus:false})); 
        studentDetails.push(student);
        student.paymentStatus =true;
        emit studentPaymentReceived(_studentname, _level);
         }

// to add new staff
uint staff_id;
        function addStaff(address _staffAddress, string memory _staffname, string memory _gender) external{
        staff_id = staff_id + 1;
        StaffDetails memory staff =(StaffDetails({id: staff_id, staffAddress: _staffAddress, staff_fullname : _staffname, gender:_gender,paymentStatus:false}));
        staffDetails.push(staff);

        emit addedNewStaff(_staffname);

    }

    //     function receiveStudentPayment(address)external {
    // }
function getStudent(uint256 _id)external view returns( StudentDetails  memory){
    for(uint i; i < studentDetails.length; i++){
        if(studentDetails[i].id == _id){
     return studentDetails[i];
        }
    }
}

function getStaff()external view returns(StaffDetails [] memory){
     return staffDetails;
}

// to pay staff
    uint [] allStaffAccount ;
    function payStaff(uint256 _id,
     string memory _staffname)external   {
        for(uint256 i; i >= staffDetails.length; i++){
        if(staffDetails[i].id == _id) {
    require(staffDetails[i].paymentStatus == false, "Staff has been paid");
        require(staffDetails[i].staffAddress != address(0), "Can't make payment to address zero");
        require(paymentToken.balanceOf(address(this)) >= staffSalary ,"Insufficient fund");
        allStaffAccount =staffDetails[i].staffAddress;
        }
    
        emit staffPaid(_staffname);
            }
        }
        // return true;
    
}
