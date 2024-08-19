import { BaseEntity } from ".";

export interface UserSettingsEntity  extends BaseEntity {
  userId: string;
  isAnonymous: string;
  showPicutres: string;
  storyPosts: string;
}
