importScripts(
  'https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js'
);
importScripts(
  'https://www.gstatic.com/firebasejs/10.8.0/firebase-messaging-compat.js'
);

firebase.initializeApp({
  apiKey: 'AIzaSyCcAdu5KxY3PJDEupWgUSmDYuFOEWbuI0Y',
  authDomain: 'fintrack-server.firebaseapp.com',
  projectId: 'fintrack-server',
  storageBucket: 'fintrack-server.firebasestorage.app',
  messagingSenderId: '132077694198',
  appId: '1:132077694198:web:bc9f35b9a98430a2dd10d7',
  measurementId: 'G-9L3TS7FRCP',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
  console.log('[firebase-messaging-sw.js] Mensagem em background:', payload);
  const { title, body } = payload.notification;

  self.registration.showNotification(title, {
    body: body,
  });
});
