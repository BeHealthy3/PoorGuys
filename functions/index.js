/* eslint-disable padded-blocks */
/* eslint-disable indent */
/* eslint-disable max-len */
/* eslint-disable no-trailing-spaces */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const uuid = require("uuid");

// Initialize Firebase Admin SDK
admin.initializeApp();

// eslint-disable-next-line max-len
exports.announceCommentAddedIfAdded = functions.firestore.document("posts/{postId}")
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
          const notificationMessage = commentedUserNickname + "님께서 게시글에 댓글을 달았습니다.:" + newlyAddedComment.content;
          const notificationDate = new Date();
          const postID = oldPostData.id == newPostData.id ? oldPostData.id : null;
          const isChecked = false;
          const notification = {
          "id": uuid.v4(),
          "notificationMessage": notificationMessage,
          "notificationDate": notificationDate,
          "postID": postID,
          "commentID": newlyAddedComment.id,
          "isChecked": isChecked,
          };
          const docRef = admin.firestore().collection("notifications").doc(userID);
          
          try {
            const doc = await docRef.get();

            if (doc.exists) {
              const oldNotifications = doc.data().notifications || [];
              const updatedNotifications = [...oldNotifications, notification];
          
              await docRef.update({notifications: updatedNotifications});
            } else {
              console.log("해당 다큐먼트가 존재하지 않음");
            }

          } catch (error) {
            console.error("Error getting document:", error);
          }
          
        } else {
          console.log("댓글이 추가되었지만, 추가된 유저가 1명이 아님");
        }
      }
    });
