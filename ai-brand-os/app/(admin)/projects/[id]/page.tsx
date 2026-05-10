export default function ProjectPage({ params }: { params: { id: string } }) {
  return <main><h1>Project {params.id}</h1></main>;
}
