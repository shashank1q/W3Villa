You need to run the project locally because I can host frontend code on github pages but can't host api on server for free.

Software required
1. Flutter
2. Node Js
3. MongoDB

once all three software are installed on local machine
*Starting MongoDB* 
1. open MongoDB compass (installed with MongoDB)
2. create connection and start the mongoDB server
3. copy connection url

*Starting Node JS* 

4. download this repository and navigate to "taskBackend/index.js"
5. on line 19, replace the existing url with the connection url you just copied.
6. save and close the file
7. open terminal inside "taskBackend" directory and run `node index`

*Starting Flutter*

8. now navigate to "task/lib" directory
9. open terminal and run `flutter run`
10. you will be asked to select device. Choose any browser from the list.

The project will be running perfectly
