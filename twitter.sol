// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Twitter {

    struct tweet {
        uint id;
        string content;
        address author;
        uint createdAt; 
    }

    struct message {

        uint id;
        address from;
        address to;
        string content;
        uint createdAt;

    }

    mapping(uint => tweet) public tweetData;
    mapping(address =>message[] ) public messageData;
    mapping(address => uint[]) public tweetOf;
    mapping(address => mapping (address => bool)) public access;
    mapping (address => address[]) public followed;


    uint nextId;
    uint nextMessageId;




    function _tweet(address _from, string memory _content) internal  {
        require(_from == msg.sender || access[_from][msg.sender], "You don't have access");
        tweetData[nextId] = tweet(nextId,_content,_from, block.timestamp);
        tweetOf[_from].push(nextId);
        nextId++;


    }

    function _message (address _from,address _to, string memory _content) internal {
        require(_from == msg.sender || access[_from][msg.sender], "You don't have access");
        messageData[_from].push(message(nextMessageId,_from,_to,_content,block.timestamp));
        nextMessageId++;

    }

     function _Tweet(string memory _content) public  {
     _tweet(msg.sender,_content);


    }

    function _Tweet(address _from,string memory _content) public  {
     _tweet(_from,_content);


    }

    function _Message (address _to, string memory _content) public {
      _message(msg.sender, _to, _content);

    }

    function _Message (address _from,address _to, string memory _content) public {
      _message(_from, _to, _content);

    }

    function following(address _to) public {
        followed[msg.sender].push(_to);

    }



    function _access(address _to, bool value) public {
        access[msg.sender][_to] = value;

    }

    function getLatestTweets (uint count) public view returns(tweet[] memory){
        require (count >0 && count < nextId);
        tweet[] memory tweets = new tweet[] (count);

        uint k;

        for(uint i = nextId-count; i<nextId; i++) {
            tweet storage _structure = tweetData[i];
            tweets[k] = tweet(_structure.id,
                              _structure.content,
                              _structure.author,
                              _structure.createdAt);
            k ++;

        }

    return ( tweets);

    }

    function getLatestofUser(address _user,uint count) public view returns(tweet[] memory) { //7

        tweet[] memory _tweets= new tweet[](count);//new memory array whoose length is count

        //tweetsOf[_user] is having all the id's of the user

        uint[] memory ids = tweetOf[_user]; ///ids is an array



        require(count>0 && count<=ids.length,"Count is not defined");

        uint j;

        for (uint i= ids.length-count;i<ids.length;i++){

        tweet storage _structure = tweetData[ids[i]];
        _tweets[j]=tweet(_structure.id,
                         _structure.content,
                         _structure.author,
                         _structure.createdAt);

          j++;

        }

    return _tweets;

        }
    }

