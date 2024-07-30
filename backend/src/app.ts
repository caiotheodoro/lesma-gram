import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import { pool } from './database';
import { ActivityController, UserActivityController, UserController } from './modules';
import { AuthController } from './modules/auth/controller';
import { authMiddleware } from './middlewares/auth';
const app = express();
app.use(cors());
app.use(bodyParser.json());

const userActivityController = new UserActivityController(pool);
const userController = new UserController(pool);
const activitiesController = new ActivityController(pool);
const authController = new AuthController(pool);

app.use('/user-activities', authMiddleware, userActivityController.getRouter());
app.use('/users', authMiddleware, userController.getRouter());
app.use('/activities', authMiddleware, activitiesController.getRouter());
app.use('/auth', authController.getRouter());

app.listen(3025, () => {
  console.log('Listening to 3025');
});
