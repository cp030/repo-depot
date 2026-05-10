export default function ReviewPage({ params }: { params: { id: string } }) {
  return <main><h1>Review {params.id}</h1></main>;
}
