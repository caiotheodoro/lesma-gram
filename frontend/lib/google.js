
import { initializeApp } from "firebase/app";
import { getAnalytics, GoogleAuthProvider} from "firebase/analytics";


const firebaseConfig = {
  apiKey: "AIzaSyCIOrK3gGdBP6oIZv0-A9HM82S-MmlozTM",
  authDomain: "prog-app-1e456.firebaseapp.com",
  projectId: "prog-app-1e456",
  storageBucket: "prog-app-1e456.appspot.com",
  messagingSenderId: "671957391243",
  appId: "1:671957391243:web:9e7f9d8d2d29f5478d818e",
  measurementId: "G-2W9CQCM472"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);