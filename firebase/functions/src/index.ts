// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
import * as functions from 'firebase-functions';

// The Firebase Admin SDK to access Cloud Firestore.
import * as admin from 'firebase-admin';
import { HttpsError } from 'firebase-functions/lib/providers/https';
admin.initializeApp();

// Store Cloud Firestore instance as const
const db = admin.firestore();
const region = functions.region('europe-west3');

// Separate Collection References (Good Practice)
const contentsRef = db.collection('contents');
const questionsRef = db.collection('questions');

export const getContents = region.https.onCall(async (data, context) => {
  // We don't use the offset yet, but it can be retrieved this way:
  // const offset = data.offset;
  // TODO: Sort by creationDate (Use meta data: doc.metadata.createdAt)
  const contents = await contentsRef.get();
  return contents.docs.map((doc) => doc.id);
});

export const getQuestion = region.https.onCall(async (data, context) => {
  const currentQuestionId = data?.currentQuestionId;
  const currentAnswerIndex = data?.currentAnswerIndex;

  interface Response {
    isCurrentAnswerCorrect?: Boolean;
    nextQuestionId: String;
    nextQuestion: any;
  }

  let response: Response = {
    nextQuestionId: '',
    nextQuestion: {},
  };

  if (currentQuestionId) {
    if (typeof currentAnswerIndex === 'undefined')
      throw new HttpsError(
        'invalid-argument',
        'No answer to previous question found'
      );

    const currentQuestion = await questionsRef.doc(currentQuestionId).get();

    if (!currentQuestion.exists)
      throw new HttpsError('invalid-argument', 'Previous question not found');

    response.isCurrentAnswerCorrect =
      currentQuestion.data()!['solution'] == currentAnswerIndex;
  }

  let nextQuestion;

  do {
    // Generate a new document which will have a random ID
    // We use this as a comparision to get a random document from Firestore
    var key = questionsRef.doc().id;
    let snapshot = await questionsRef
      .where(admin.firestore.FieldPath.documentId(), '>=', key)
      .limit(1)
      .get();

    if (snapshot.size > 0) {
      // We found a Document randomly
      nextQuestion = snapshot.docs[0];
    } else {
      // Our ID is greater than all other IDs => return last item
      snapshot = await questionsRef
        .where(admin.firestore.FieldPath.documentId(), '<', key)
        .limit(1)
        .get();

      nextQuestion = snapshot.docs[0];
    }
  } while (nextQuestion.id == currentQuestionId);

  response.nextQuestionId = nextQuestion.id;
  response.nextQuestion = nextQuestion.data();
  delete response.nextQuestion['solution'];

  return response;
});
