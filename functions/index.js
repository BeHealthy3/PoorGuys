/* eslint-disable no-unused-vars */
/* eslint-disable require-jsdoc */
/* eslint-disable padded-blocks */
/* eslint-disable indent */
/* eslint-disable max-len */
/* eslint-disable no-trailing-spaces */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const uuid = require("uuid");

// Initialize Firebase Admin SDK
admin.initializeApp();

class Notification {
  constructor(id, message, date, postID, commentID, isChecked) {
      this.id = id;
      this.notificationMessage = message;
      this.notificationDate = date;
      this.postID = postID;
      this.commentID = commentID;
      this.isChecked = isChecked;
  }
}

// eslint-disable-next-line max-len
exports.postChanged = functions.firestore.document("posts/{postId}")
    .onUpdate(async (change, context) => {
      const oldPostData = change.before.data();
      const newPostData = change.after.data();
      const userID = newPostData.userID;

      const oldPostComments = oldPostData.comments;
      const newPostComments = newPostData.comments;
      
      const newlyAddedComments = newPostComments.filter((newComment) => {
        return !oldPostComments.some((oldComment) => oldComment.id === newComment.id);
      });
      const newlyAddedComment = newlyAddedComments[0];

      if (oldPostData.comments.length < newPostData.comments.length) {
      
        if (newlyAddedComments.length == 1) {

          const commentedUserNickname = newlyAddedComment.nickName;
          const notificationMessage = `${commentedUserNickname}님께서 게시글에 댓글을 달았습니다. "${newlyAddedComment.content}"`;
          const notificationDate = new Date();
          const postID = oldPostData.id == newPostData.id ? oldPostData.id : null;
          const isChecked = false;
          const db = admin.firestore();
          const notification = {
              id: uuid.v4(),
              notificationMessage: notificationMessage,
              notificationDate: notificationDate,
              postID: postID,
              commentID: newlyAddedComment.id,
              isChecked: isChecked,
          };

          // Create a notification document in the user's subcollection
          const userNotificationRef = db.collection("users").doc(userID).collection("notifications").doc(notification.id);
          await userNotificationRef.set(notification);
          
        } else {
          console.log("댓글이 추가되었지만, 추가된 유저가 1명이 아님");
        }
      }
    });

exports.createNotificationOnUserCreation = functions.firestore
.document("users/{userId}")
.onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const userDocData = snapshot.data();

    // Create a notification object
    const notificationMessage = "🎉어푸어푸에 가입하신 것을 환영합니다. 어푸어푸는 여러분의 즐겁고 합리적인 소비생활을 응원합니다!";
    const notificationDate = new Date();
    const isChecked = false;
    const notification = {
        id: uuid.v4(),
        notificationMessage: notificationMessage,
        notificationDate: notificationDate,
        postID: null, // You can customize this value
        commentID: null, // You can customize this value
        isChecked: false,
    };

    // Create a user-specific notification document in the user's subcollection
    const userNotificationRef = admin.firestore().collection("users").doc(userId).collection("notifications").doc(notification.id);
    await userNotificationRef.set(notification);
});
