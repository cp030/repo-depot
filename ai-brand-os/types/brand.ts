export interface BrandProject {
  id: string;
  name: string;
  clientName: string;
  status: "draft" | "in_progress" | "review" | "complete";
  createdAt: string;
  updatedAt: string;
}

export interface BrandKit {
  projectId: string;
  colors: string[];
  fonts: string[];
  logoUrl?: string;
  voiceGuide?: string;
}
